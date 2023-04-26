import os
import shutil
import uuid
import logging

from selenium import webdriver

logger = logging.getLogger()

class WebBrowser:
    def __init__(self, width=1916, height=1094):
        driver_version = "88.0.4324.96"
        self._tmp_folder = '/tmp/{}'.format(uuid.uuid4())

        if not os.path.exists(self._tmp_folder):
            os.makedirs(self._tmp_folder)

        if not os.path.exists(self._tmp_folder + '/user-data'):
            os.makedirs(self._tmp_folder + '/user-data')

        if not os.path.exists(self._tmp_folder + '/data-path'):
            os.makedirs(self._tmp_folder + '/data-path')

        if not os.path.exists(self._tmp_folder + '/cache-dir'):
            os.makedirs(self._tmp_folder + '/cache-dir')

        chrome_options=self.__get_default_chrome_options()
        chrome_options.add_argument('--window-size={}x{}'.format(width, height))
        # chrome_options.add_argument('--hide-scrollbars')

        self.driver = webdriver.Chrome(executable_path='/opt/chromedriver/' + driver_version + '/chromedriver',
                                  options=chrome_options,
                                  service_log_path=self._tmp_folder + '/chromedriver.log')

    def __get_default_chrome_options(self):
        br_version = "88.0.4324.150"
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument('--headless')
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--disable-dev-tools")
        chrome_options.add_argument("--no-zygote")
        chrome_options.add_argument("--single-process")
        # chrome_options.add_argument("window-size=2560x1440")
        chrome_options.add_argument("--remote-debugging-port=9222")
        chrome_options.add_argument('--user-data-dir={}'.format(self._tmp_folder + '/user-data'))
        chrome_options.add_argument('--data-path={}'.format(self._tmp_folder + '/data-path'))
        chrome_options.add_argument('--homedir={}'.format(self._tmp_folder))
        chrome_options.add_argument('--disk-cache-dir={}'.format(self._tmp_folder + '/cache-dir'))
        chrome_options.binary_location = '/opt/chrome/' + br_version + '/chrome'

        return chrome_options      

    # def __get_correct_height(self, url, width=1280):
    #     chrome_options=self.__get_default_chrome_options()
    #     chrome_options.add_argument('--window-size={}x{}'.format(width, 1024))
    #     driver = webdriver.Chrome(chrome_options=chrome_options)
    #     driver.get(url)
    #     height = driver.execute_script("return Math.max( document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight )")
    #     driver.quit()
    #     return height


    def save_screenshot(self, url, filename, width=1280, height=None):
        logger.info('Using Chrome version: {}'.format(self.driver.capabilities['browserVersion']))
        self.driver.get(url)
        self.driver.save_screenshot(filename)


    def close(self):
        self.driver.quit()
        # Remove specific tmp dir of this "run"
        shutil.rmtree(self._tmp_folder)


 