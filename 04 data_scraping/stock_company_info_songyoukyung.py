import os
import requests
from bs4 import BeautifulSoup as bs
import pandas as pd
import time
from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()

page=1
company_infos=[]
while True:
    url="https://kind.krx.co.kr/corpgeneral/corpList.do"
    payload=dict(method="searchCorpList",pageindex=page,currentPageSize=100,orderMode=3,orderStat="D",searchType=13,fiscalYearEnd="all",location="all")
    r = requests.post(url,data=payload)
    soup = bs(r.content, 'lxml')
    time.sleep(5)
    total_page=int(soup.select_one('.info.type-00 > em').text.replace(',',''))//100+1
    for idx,tr in enumerate(soup.select("tbody>tr")):
        print(f'{page}/{total_page} 중 {idx+1}/{len(soup.select("tbody>tr"))} 작업중', end="\r")
        stock_type=tr.select_one('td:nth-child(1) > img')['alt']
        company_name=tr.select_one('td:nth-child(1)> a ')['title']
        stock_code=tr.select_one('td:nth-child(1) > a ')['onclick'].split("'")[1]
        business_type=tr.select_one('td:nth-child(2)')['title']
        product=tr.select_one('td:nth-child(3)')['title']
        listing_date=tr.select_one('td:nth-child(4)').text
        settlement=tr.select_one('td:nth-child(5)').text
        ceo=tr.select_one('td:nth-child(6)')['title']
        homepage=tr.select_one('td:nth-child(7) > a')['href'] if tr.select_one('td:nth-child(7) > a')!=None else ""
        region=tr.select_one('td:nth-child(8)').text
        company_infos.append((stock_type,company_name,stock_code,business_type,product,listing_date,settlement,ceo,homepage,region))
    if page < total_page:
        page+=1
    else:
        break
    
# 컬럼명
columns = soup.select_one('table')['summary'].split(", ")
columns.insert(0,'증권종류')
columns.insert(2,'종목코드')
df=pd.DataFrame(company_infos,columns=columns)

from datetime import datetime
today=datetime.now()
today=f"{today.year}{today.month:02d}{today.day:02d}"

engine = create_engine("mysql+pymysql://root:1234@127.0.0.1:3306/korean_stock")
conn=engine.connect()
df.to_sql(f"company_info_{today}",con=conn, if_exists='replace', index=False)
conn.close()

