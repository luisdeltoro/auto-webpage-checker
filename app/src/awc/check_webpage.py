import os

from selenium.webdriver.common.by import By

from awc.sns_notifier import SnsNotifier
from awc.webbrowser import WebBrowser


def handler(event, context):
    print("Lambda started")
    success = main()
    print("Lambda finished with success=" + str(success))

def main():
    num_of_available_days = check_website()
    notification_mode = os.environ.get('NOTIFICATION_MODE') or 'ON_SUCCESS'
    print(f"Condition debugging: {'SNS_TOPIC_ARN' in os.environ} - {num_of_available_days > 0} - {notification_mode == 'ALWAYS'}")
    if ('SNS_TOPIC_ARN' in os.environ) and (num_of_available_days > 0 or notification_mode == 'ALWAYS'):
        notifier = SnsNotifier()
        message = f"I found: {num_of_available_days} available days"
        notifier.send_notification(message)
    return num_of_available_days > 0


def check_website():
    # Load the webpage
    url = os.environ.get('WEB_URL') or 'https://service.berlin.de/terminvereinbarung/termin/tag.php?termin=1&dienstleister=122285&anliegen[]=121591&herkunft=1'
    driver = WebBrowser().driver
    driver.get(url)

    # Check available appointments
    num_buchbar_elements_p1 = check_elements(driver, "buchbar")

    if num_buchbar_elements_p1 > 1:
        print(f"{num_buchbar_elements_p1 - 1} Available appointments found on page 1")
        return num_buchbar_elements_p1 - 1
    else:
        print("No available appointments on page 1")
        # Click to show next month
        driver.find_element(By.LINK_TEXT, "»").click()
        # Check available appointments
        num_buchbar_elements_p2 = check_elements(driver, "buchbar")
        if num_buchbar_elements_p2 > 1:
            print(f"{num_buchbar_elements_p2 - 1} Available appointments found on page 1")
            return num_buchbar_elements_p2 - 1
        else:
            print("No available appointments on page 2")
            return 0

    # Close the browser window
    driver.quit()


def check_elements(driver, class_name):
    buchbar_elements = driver.find_elements(By.CLASS_NAME, class_name)
    num_buchbar_elements = len(buchbar_elements)
    for buchbar_element in buchbar_elements:
        print(buchbar_element.text)
    return num_buchbar_elements


if __name__ == '__main__':
    main()