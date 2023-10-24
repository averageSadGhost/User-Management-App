import time
from fastapi import FastAPI
from . import utils, database
from .routers import auth, users


app = FastAPI()

database.Base.metadata.create_all(bind=database.engine)

start_time = time.time()


@app.get("/", tags=["Main"], summary="Main route & Uptime", description="Check the server's uptime.")
def root():
    """
    Check the server's uptime.
    """

    uptime_string = utils.get_up_time(start_time)

    return {"detail": f"The server is up and running for {uptime_string}."}


app.include_router(auth.router)

app.include_router(users.router)
