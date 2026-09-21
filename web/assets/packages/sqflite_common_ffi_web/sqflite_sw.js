/**
 * SQLite worker adapter for sqflite_common_ffi_web
 * 
 * This is a simplified implementation that will be used instead of the 
 * standard worker if the original worker file is not found.
 */

(function () {
    // Handle messages from the main thread
    self.onmessage = async function (e) {
        const data = e.data;
        const method = data.method;
        const id = data.id;

        try {
            // Load SQL.js if not already loaded
            if (!self.SQL) {
                self.importScripts('https://cdn.jsdelivr.net/npm/sql.js@1.8.0/dist/sql-wasm.js');
                self.SQL = await initSqlJs({
                    locateFile: file => `https://cdn.jsdelivr.net/npm/sql.js@1.8.0/dist/${file}`
                });
            }

            let result;
            switch (method) {
                case 'openDatabase':
                    self.db = new self.SQL.Database();
                    result = { id: 1 }; // Mock database ID
                    break;

                case 'closeDatabase':
                    if (self.db) {
                        self.db.close();
                        self.db = null;
                    }
                    result = true;
                    break;

                case 'execute':
                case 'executeBatch':
                case 'query':
                    if (!self.db) {
                        throw new Error('Database not opened');
                    }

                    const operations = method === 'executeBatch' ? data.operations : [{ sql: data.sql, arguments: data.arguments || [] }];
                    const results = [];

                    for (const op of operations) {
                        const sql = op.sql;
                        const params = op.arguments || [];

                        if (sql.trim().toLowerCase().startsWith('select') || sql.includes('pragma')) {
                            // Handle SELECT queries
                            try {
                                const stmt = self.db.prepare(sql);
                                stmt.bind(params);

                                const rows = [];
                                while (stmt.step()) {
                                    rows.push(stmt.getAsObject());
                                }
                                stmt.free();

                                results.push({
                                    columns: Object.keys(rows[0] || {}),
                                    rows: rows
                                });
                            } catch (error) {
                                console.error('Error executing query:', sql, error);
                                throw error;
                            }
                        } else {
                            // Handle non-SELECT queries
                            try {
                                self.db.run(sql, params);
                                results.push({
                                    rowsAffected: self.db.getRowsModified(),
                                    insertId: null // SQL.js doesn't provide lastInsertRowId easily
                                });
                            } catch (error) {
                                console.error('Error executing statement:', sql, error);
                                throw error;
                            }
                        }
                    }

                    result = method === 'executeBatch' ? results : results[0];
                    break;

                default:
                    console.warn(`Unhandled method: ${method}`);
                    result = null;
                    break;
            }

            // Send the result back to the main thread
            self.postMessage({
                id: id,
                result: result,
                error: null
            });
        } catch (error) {
            console.error('Worker error:', error);
            // Send any errors back to the main thread
            self.postMessage({
                id: id,
                result: null,
                error: {
                    message: error.message,
                    code: 'sqlite_error'
                }
            });
        }
    };

    // Let the main thread know we're ready
    self.postMessage({ ready: true });
})();
