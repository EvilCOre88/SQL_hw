import json
import sqlalchemy

from sqlalchemy.orm import sessionmaker
from Models import create_tables, Publisher, Book, Shop, Stock, Sale


if __name__ == '__main__':

    DSN = 'postgresql://postgres:Qwerty2022@localhost:5432/sql_alchemy_hw'
    engine = sqlalchemy.create_engine(DSN)
    create_tables(engine)

    Session = sessionmaker(bind=engine)
    session = Session()

    with open('data.json') as f:
        info = json.load(f)
    for unit in info:
        model = {'publisher': Publisher,
                 'book': Book,
                 'shop': Shop,
                 'stock': Stock,
                 'sale': Sale
                 }[unit.get('model')]
        session.add(model(id=unit.get('pk'), **unit.get('fields')))
    session.commit()

    query = session.query(Shop)
    query = query.join(Stock, Stock.id_shop == Shop.id)
    query = query.join(Book, Book.id == Stock.id_book)
    query = query.join(Publisher, Publisher.id == Book.id_publisher)
    publ = input('Введите имя или идентификатор издателя: ')
    try:
        publ = int(publ)
        records = query.filter(Publisher.id == publ)
    except ValueError:
        records = query.filter(Publisher.name == publ)
    for shop in records:
        print(shop)
    session.close()