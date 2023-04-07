import os
import tempfile
import jinja2
import uvicorn

from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from google.cloud import storage

from pydantic import BaseModel
from typing import List


app = FastAPI()
env = jinja2.Environment(loader=jinja2.PackageLoader("main"), autoescape=jinja2.select_autoescape())
template = env.get_template("receipt.j2")

client = storage.Client()
gcpBucket = os.getenv("BUCKET")
checks = {}


class Item(BaseModel):
    name: str
    price: float | None = 0
    ready: bool | None = False

class Check(BaseModel):
    orderId: str
    items: List[Item]
    total: float | None = 0
    url: str | None = ""


def upload_receipt(orderId: str, receipt: str):
    try:
        key = f'{orderId}.txt'    
        bucket = client.get_bucket(gcpBucket)
        blob = bucket.blob(key)
        blob.upload_from_string(receipt)
        acl = blob.acl
        acl.all().grant_read()
        acl.save()
        return blob.public_url
    except Exception as e:
        print("failed to upload: ", e)
        return ""

@app.get("/healthz")
async def healthz():
    return {"message": "Check please 🫰!"}


@app.get("/checks", response_model=list[Check])
async def getChecks():
    response = []
    for checkID in checks:
        response.append(checks[checkID])

    return response

@app.post("/checks", status_code=200)
async def prepare_check(check: Check):
    # calculate price
    total = 0
    for i in range(len(check.items)):
        item = check.items[i]
        price = len(item.name)
        check.items[i].price = price
        total += price

    check.total = total
    receipt = template.render(total=check.total, items=check.items, check_id=check.orderId)
    check.url = upload_receipt(check.orderId, receipt)
    checks[check.orderId] = check
    print(("The total for check {check_id} is: ${total} 🧮").format(check_id=check.orderId, total=check.total))
    
@app.get("/checks/{check_id}")
async def getCheck(check_id):
    if check_id in checks.keys():
        return checks[check_id]
    raise HTTPException(status_code=404, detail="Check not found 👎🏼")

@app.delete("/checks/{check_id}")
async def payCheck(check_id):
    if check_id in checks.keys():
        del checks[check_id]
        return
    
    raise HTTPException(status_code=404, detail="Check not found 👎🏼")

app.mount("/", StaticFiles(directory="public", html=True), name="public")

if __name__ == "__main__":
   reload=bool(os.getenv("RELOAD"))
   uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=reload)