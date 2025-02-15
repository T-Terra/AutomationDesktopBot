import requests
from dotenv import load_dotenv
import os

load_dotenv()

def sendImage(fileName):
    url = os.getenv("WEBHOOK_IMG")
    headers = {}
    data = {
        "content": "",
    }
    files = {
        "file1": open(f"./img/{fileName}", "rb")
    }

    response = requests.post(url, headers=headers, data=data, files=files)

    res = response.json()
    return res['attachments'][0]['url']