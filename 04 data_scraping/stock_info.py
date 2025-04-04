import requests
import time
import os
import pandas as pd
from datetime import datetime
from bs4 import BeautifulSoup as bs
from sqlalchemy import create_engine, text
import pymysql
pymysql.install_as_MySQLdb()

page=1
company_infos=[]
while True:
    url2='https://kind.krx.co.kr/corpgeneral/corpList.do'
    payload = dict(method='searchCorpList', pageIndex=page, currentPageSize=100, 
                   orderMode=3, orderStat='D', searchType=13, fiscalYearEnd='all', 
                   location='all')
    r=requests.post(url2,data=payload)
    #print(r.status_code)
    soup = bs(r.content, 'lxml')
    time.sleep(5)
    total_page=int(soup.select_one('.info.type-00 > em').text.replace(',','')) // 100 +1
    for idx,tr in enumerate(soup.select("tbody>tr")):
        print(f'{page}/{total_page} 중 {idx+1}/{len(soup.select("tbody>tr"))} 작업중', end="\r")
        #tr= soup.select("tbody > tr")[i]
        stock_type= tr.select_one('td:nth-child(1) > img')['alt']
        company_name= tr.select_one('td:nth-child(1) > a')['title']
        stock_code= tr.select_one('td:nth-child(1) > a')['onclick'].split("'")[1]
        business_type=tr.select_one('td:nth-child(2)')['title']
        product=tr.select_one('td:nth-child(3)')['title']
        resi_date=tr.select_one('td:nth-child(4)').text
        settlement=tr.select_one('td:nth-child(5)').text
        ceo=tr.select_one('td:nth-child(6)')['title']
        homepage=tr.select_one('td:nth-child(7) > a')['href'] if tr.select_one('td:nth-child(7) > a') !=None else ""
        region=tr.select_one('td:nth-child(8)').text
        company_infos.append((stock_type,company_name,stock_code,business_type,product,resi_date,settlement,ceo,homepage,region))
    if page < total_page:
        page+=1
    else:
        break
    
columns = soup.select_one('table')['summary'].split(", ")
columns.insert(0,'주식종목')
columns.insert(2,'종목코드')
#print(columns)
df=pd.DataFrame(company_infos,columns=columns)

from datetime import datetime
today=datetime.now()
today=f"{today.year}{today.month:02d}{today.day:02d}"

# exe 파일 저장위치가 다르기 때문에 저장 경로를 만들어줘야 함.
if not os.path.exists("./scraping_results"):
    os.mkdir("scraping_results")

df.to_csv(f"./scraping_results/상장기업정보({today}).csv",encoding="utf-8",index=False)
print(f"./scraping_results/상장기업정보({today}).csv 저장완료!")

engine = create_engine("mysql+pymysql://root:1234@localhost:3306/stock_info")
conn = engine.connect()
df.to_sql(f"stock_company_info_{today}",con=conn, if_exists='replace', index=False)
print(f"stock_company_info_{today} 데이터베이스 저장완료!")
conn.close()