import requests
from bs4 import BeautifulSoup as bs
import os
import pandas as pd
import time
from datetime import datetime
from sqlalchemy import create_engine
import pymysql
pymysql.install_as_MySQLdb()

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

    options = Options()
    options.add_experimental_option("detach", True)
    options.add_argument("start-maximized")
    options.add_argument("Chrome/135.0.0.0")
    options.add_argument("lang=ko_KR")

    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        options=options
        )

    url="https://translate.google.com/?hl=ko&sl=ko&tl=en&op=translate"
    driver.get(url)

    wait = WebDriverWait(driver, 10)
    text_box = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "div > textarea")))
    
    text=input("검색할 내용을 입력해주세요:")
    text_box.send_keys(f"{text}")
    text_box.send_keys(Keys.ENTER)
    time.sleep(1)