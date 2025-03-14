from dotenv import load_dotenv
import os

load_dotenv(override=True)

def readDot():
    url = os.getenv("WEBHOOK_MAIN")
    return url

def readLinkedinEnv():
    return os.getenv("HEADLESS", "True").lower() == "true" or "False"

def readLinkedinLogin():
    return [os.getenv("EMAIL"), os.getenv("PASSWORD")]