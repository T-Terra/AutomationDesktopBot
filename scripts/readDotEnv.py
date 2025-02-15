from dotenv import load_dotenv
import os

load_dotenv()

def readDot():
    url = os.getenv("WEBHOOK_MAIN")
    return url