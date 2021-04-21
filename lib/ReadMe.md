step 1 : https://pypi.org/project/PyMLX90614/#files

step 2 : Download and extract the file 

         Paste the below link on command propmt  and hit <Enter> to download the zip file 
         https://files.pythonhosted.org/packages/67/8a/443af31ff99cca1e30304dba28a60d3f07d247c8d410822411054e170c9c/PyMLX90614-0.0.3.tar.gz

        Extract the file using fllowing command
         ->  PyMLX90614-0.0.3.tar.gz


step 3 :Go to the extracted folder cd PyMLX90614-0.0.3/

step 4 : Install the following package 
        ->  Sudo apt-get install python-setuptools
        ->  sudo apt-get install -y i2c-tools
        ->  sudo python setup.py install

step 5 : run following command for checking i2c 
            -> ls /dev/*i2c*
step 6 : -> i2cdetect -y 1

step 7 : create new python file  and paste the following code  
            from smbus2 import SMBus
            from mlx90614 import MLX90614

            bus = SMBus(1)
            sensor = MLX90614(bus, address=0x5A)
            print sensor.get_ambient()
            print sensor.get_object_1()
            bus.close()

step 8 : Run the above code and read the values from MLX90416 Sensore