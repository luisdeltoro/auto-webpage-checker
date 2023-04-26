import os
import shutil
import uuid

from selenium import webdriver

from awc.logging import configure_logger

logger = configure_logger()

class WebBrowser:
    def __init__(self, browser_version='88.0.4324.150', driver_version = '88.0.4324.96', width=1916, height=1094):
        self._tmp_folder = '/tmp/{}'.format(uuid.uuid4())

        if not os.path.exists(self._tmp_folder):
            os.makedirs(self._tmp_folder)

        if not os.path.exists(self._tmp_folder + '/user-data'):
            os.makedirs(self._tmp_folder + '/user-data')

        if not os.path.exists(self._tmp_folder + '/data-path'):
            os.makedirs(self._tmp_folder + '/data-path')

        if not os.path.exists(self._tmp_folder + '/cache-dir'):
            os.makedirs(self._tmp_folder + '/cache-dir')

        chrome_options=self.__get_default_chrome_options(browser_version)
        chrome_options.add_argument('--window-size={}x{}'.format(width, height))

        self.driver = webdriver.Chrome(executable_path='/opt/chromedriver/' + driver_version + '/chromedriver',
                                  options=chrome_options,
                                  service_log_path=self._tmp_folder + '/chromedriver.log')

    def __get_default_chrome_options(self, browser_version):
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument('--headless')
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--disable-dev-tools")
        chrome_options.add_argument("--no-zygote")
        chrome_options.add_argument("--single-process")
        chrome_options.add_argument("--remote-debugging-port=9222")
        chrome_options.add_argument('--user-data-dir={}'.format(self._tmp_folder + '/user-data'))
        chrome_options.add_argument('--data-path={}'.format(self._tmp_folder + '/data-path'))
        chrome_options.add_argument('--homedir={}'.format(self._tmp_folder))
        chrome_options.add_argument('--disk-cache-dir={}'.format(self._tmp_folder + '/cache-dir'))
        chrome_options.binary_location = '/opt/chrome/' + browser_version + '/chrome'
        return chrome_options


    def close(self):
        self.driver.quit()
        # Remove specific tmp dir of this "run"
        shutil.rmtree(self._tmp_folder)


 