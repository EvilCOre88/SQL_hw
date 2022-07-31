import psycopg2

from psycopg2.extensions import AsIs


def create_client_sheet(conn):
    with conn.cursor() as cursor:
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS clients(
        client_id SERIAL PRIMARY KEY,
        name VARCHAR(50) NOT NULL,
        surname VARCHAR(50) NOT NULL,
        email VARCHAR(60) NOT NULL
        );
        ''')

def create_phone_sheet(conn):
    with conn.cursor() as cursor:
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS phones(
        phone_id SERIAL PRIMARY KEY,
        number VARCHAR(20),
        client_id INTEGER NOT NULL REFERENCES clients(client_id)
        );
        ''')

def clear_sheets(conn):
    with conn.cursor() as cursor:
        cursor.execute('''
        DROP TABLE clients, phones;
        ''')

def add_client(conn, name, surname, email, phones=None):
    with conn.cursor() as cursor:
        cursor.execute('''
        INSERT INTO clients(name, surname, email)
        VALUES (%s, %s, %s) RETURNING client_id;
        ''', (name, surname, email))
        client_id = cursor.fetchone()
        if phones is not None:
            if len(phones) == 1:
                cursor.execute('''
                INSERT INTO phones(number, client_id)
                VALUES (%s, %s) RETURNING phone_id;
                ''', (phones[0], client_id))
            else:
                for number in phones:
                    cursor.execute('''
                    INSERT INTO phones(number, client_id)
                    VALUES (%s, %s) RETURNING phone_id;
                    ''', (number, client_id))
        return cursor.fetchall()

def add_phone(conn, phone, client_id):
    with conn.cursor() as cursor:
        cursor.execute('''
        INSERT INTO phones(number, client_id)
        VALUES (%s, %s) RETURNING phone_id;
        ''', (phone, client_id))

def change_info(conn, client_id, field, change):
    with conn.cursor() as cursor:
        cursor.execute('''
        UPDATE clients
        SET %s = %s
        WHERE client_id = %s RETURNING client_id;
        ''', (field, change, client_id))
        cursor.fetchone()

def change_client(conn, client_id, name=None, surname=None, email=None):
    if name is not None:
        change_info(conn, client_id, AsIs('name'), name)
    if surname is not None:
        change_info(conn, client_id, AsIs('surname'), surname)
    if email is not None:
        change_info(conn, client_id, AsIs('email'), email)

def change_delete_phone(conn, client_id, old_phone, command='Для удаления - d, для изменения - c.', new_phone=None):
    with conn.cursor() as cursor:
        if command == 'd':
            cursor.execute('''
            %s FROM phones
            WHERE number = %s RETURNING phone_id;
            ''', (AsIs('DELETE'), old_phone))
            cursor.fetchone()
        elif command == 'c':
            cursor.execute('''
            %s phones
            SET number = %s
            WHERE number = %s RETURNING phone_id;
            ''', (AsIs('UPDATE'), new_phone, old_phone))
            cursor.fetchone()
        else:
            print('Не верно введена команда!')

def delete_all_phones(conn, client_id):
    with conn.cursor() as cursor:
        cursor.execute('''
        DELETE FROM phones
        WHERE client_id = %s;
        ''', (client_id,))

def delete_client(conn, client_id):
    delete_all_phones(conn, client_id)
    with conn.cursor() as cursor:
        cursor.execute('''
        DELETE FROM clients
        WHERE client_id = %s;
        ''', (client_id,))

def find_info(conn, field, rusfield, querry):
    with conn.cursor() as cursor:
        cursor.execute('''
        SELECT *
        FROM clients
        WHERE %s = %s;
        ''', (field, querry))
        print(f'\nВ базе есть следующие клиенты с {rusfield} {querry}:', cursor.fetchall())

def find_client(conn, name=None, surname=None, email=None, phone=None):
    with conn.cursor() as cursor:
        if name is not None:
            find_info(conn, AsIs('name'), AsIs('именем'), name)
        if surname is not None:
            find_info(conn, AsIs('surname'), AsIs('фамилией'), surname)
        if email is not None:
            find_info(conn, AsIs('email'), AsIs('электронной почтой'), email)
        if phone is not None:
            with conn.cursor() as cursor:
                cursor.execute('''
                SELECT c.client_id, c.name, c.surname, c.email
                FROM clients AS c
                INNER JOIN phones AS p
                ON c.client_id = p.client_id
                WHERE p.number = %s;
                ''', (phone,))
                print(f'\nВ базе есть следующие клиенты с телефоном {phone}:', cursor.fetchall())


with psycopg2.connect(database="sql_hw", user="postgres", password="Qwerty2022") as conn:
    clear_sheets(conn)
    create_client_sheet(conn)
    create_phone_sheet(conn)
    add_client(conn, 'Иван', 'Иванов', 'ivan@gmail.com', ['89253232132'])
    add_client(conn, 'Петр', 'Петров', 'petr@gmail.com', ['89253232133'])
    add_phone(conn, '89253232134', 1)
    add_phone(conn, '89253232135', 1)
    add_phone(conn, '89253232136', 1)
    add_phone(conn, '89253232137', 2)
    change_client(conn, 1, name='Валера', surname=None, email='валера@gmail.com')
    change_delete_phone(conn, 1, '89253232135', 'c', '89253232138')
    change_delete_phone(conn, 2, '89253232133', 'd')
    delete_client(conn, 1)
    find_client(conn, name='Петр')
    find_client(conn, surname='Петров')
    find_client(conn, email='petr@gmail.com')
    find_client(conn, phone='89253232137')
    find_client(conn, phone='89253232136')