import os
import requests
from bs4 import BeautifulSoup as bs
import pandas as pd
import time
import datetime
from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()

#오늘 날짜 수집
import selenium
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from io import StringIO
from ex_dbio import to_ex_db

def new_col(df):
    new_cols = []
    for col in df.columns:
        if col[0] == col[1] == col[2]:
            new_cols.append(col[0].replace(" ", "_"))
        else:
            new_cols.append(" ".join(col).strip().replace(" ", "_"))
    return new_cols

options = Options()
options.add_experimental_option("detach", True)
options.add_argument("start-maximized")
options.add_argument("Chrome/135.0.0.0")
options.add_argument("lang=ko_KR")
#웹브라우저가 백그라운드에서 작동하도록 설정
options.add_argument("--headless")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

driver = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()),
    options=options
    )

## post 방식 url 가져오기
## 개발자도구 - network - doc : preview로 가져오는 페이지 확인
url="https://www.hanabank.com/cms/rate/index.do?contentUrl=/cms/rate/wpfxd651_01i.do"
driver.get(url)
time.sleep(1)

# 오늘 날짜
today = datetime.date.today()

#날짜 넣기
calendar=driver.find_element(By.ID,"tmpInqStrDt")
calendar.clear()
calendar.send_keys(str(today).replace("-",""))
#print(f'{date} 데이터 수집 진행 중', end="\r")

#조회 버튼 클릭하기
button=driver.find_element(By.CSS_SELECTOR,".btnDefault.bg")
#button.text
button.send_keys(Keys.ENTER)
time.sleep(2)

df=pd.read_html(StringIO(driver.find_element(By.CSS_SELECTOR,".tblBasic.leftNone").get_attribute('outerHTML')))[0]
df['date']=today
new_columns=new_col(df)
df.columns=new_columns
df = df[['date','통화', '현찰_사실_때_환율', '현찰_사실_때_Spread', '현찰_파실_때_환율', '현찰_파실_때_Spread',
   '송금_보낼_때_보낼_때', '송금_받을_때_받을_때', '외화_수표_파실때', '매매_기준율', '환가_료율',
   '미화_환산율']]
to_ex_db(df)

driver.close()