import time
from typing import Union
from passlib.context import CryptContext
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def check_access_control(current_user_type, requested_user_type):
    if current_user_type == "admin":

        return True
    elif current_user_type == "tutor":

        return requested_user_type == "student"
    else:

        return False


def get_up_time(start_time: int):
    current_time = time.time()
    time_difference = current_time - start_time

    # Calculate days, hours, minutes, and seconds
    days = int(time_difference // (24 * 3600))
    time_difference = time_difference % (24 * 3600)
    hours = int(time_difference // 3600)
    time_difference %= 3600
    minutes = int(time_difference // 60)
    seconds = int(time_difference % 60)

    # Format the uptime as a string
    uptime_string = f"{days} {'day' if days == 1 else 'days'}, "
    uptime_string += f"{hours} {'hour' if hours == 1 else 'hours'}, "
    uptime_string += f"{minutes} {'minute' if minutes == 1 else 'minutes'}, and "
    uptime_string += f"{seconds} {'second' if seconds == 1 else 'seconds'}"

    return uptime_string
