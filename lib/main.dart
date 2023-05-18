import 'dart:async';

import 'package:mysql_client/mysql_client.dart';

Future main() async {
  final pool = MySQLConnectionPool(
    host: '127.0.0.1',
    port: 3306,
    userName: 'root',
    password: 'boca1978',
    maxConnections: 10,
    databaseName: 'db_test', // optional,
  );

  var stmt = await pool.prepare(
    "INSERT INTO users2 (id, name, email, age) VALUES (?, ?, ?, ?)",
  );

  await stmt.execute([null, 'Carlos', 'ffff@ddd.com', 32]);
  await stmt.execute([null, 'Jorge', '4444@rtr.com', 44]);

  await stmt.deallocate();

  var result =
//      await pool.execute("SELECT * FROM users2 WHERE id = :id", {"id": 1});
      await pool.execute("SELECT * FROM users2");

  for (final row in result.rows) {
    print(row.assoc());
  }

  await pool.transactional((conn) async {
    await conn.execute(
        "UPDATE users2 SET age = :age WHERE id = :id", {"age": 88, "id": 1});
  });

  var result2 =
//      await pool.execute("SELECT * FROM users2 WHERE id = :id", {"id": 1});
      await pool.execute("SELECT * FROM users2");

  for (final row in result2.rows) {
    print(row.assoc());
  }

  await pool.close();
}
