from selenium import webdriver
from tempfile import mkdtemp
from selenium.webdriver.common.by import By
import base64
import json

TEST_WRITE_PDF = True


def handler(event=None, context=None):

    print(event)
    print(type(event))

    options = webdriver.ChromeOptions()
    options.binary_location = '/opt/chrome/chrome'
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1920x1080")
    options.add_argument("--single-process")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--no-zygote")
    options.add_argument(f"--user-data-dir={mkdtemp()}")
    options.add_argument(f"--data-path={mkdtemp()}")
    options.add_argument(f"--disk-cache-dir={mkdtemp()}")
    options.add_argument("--remote-debugging-port=9222")
    chrome = webdriver.Chrome("/opt/chromedriver", options=options)
    chrome.get(event['queryStringParameters']['url'])
    source = chrome.page_source
    pdf_params = {
        "landscape": False,
        "displayHeaderFooter": False,
        "printBackground": True,
        "scale": 1,
        "paperWidth": 8.5,
        "paperHeight": 11,
        "marginTop": 0,
        "marginBotton": 0,
        "marginLeft": 0,
        "marginRight": 0
    }

    data = chrome.execute_cdp_cmd('Page.printToPDF', pdf_params)["data"]

    body = {
        "pdf_base64_data": data,
        "source": source
    }

    return {
        "isBase64Encoded": True,
        "statusCode": 200,
        "headers": {},
        "body": json.dumps(body)
    }

