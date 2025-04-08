from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()


def dbconnect():
    engine=create_engine("mysql+pymysql://root:1234@localhost:3306/naver_book")
    conn=engine.connect()
    return conn

def to_book_db(name, df,num):
    conn=dbconnect()
    df.to_sql(f'{name}_book_info',con=conn,if_exists="append",index=False)
    conn.close()
    print(f"{num}page : {name}_DB 저장 완료", end="\r")