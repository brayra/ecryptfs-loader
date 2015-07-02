# EcryptFS Loader

Did you ever want an encrypted directory that was easy to manage? 

How about easy to create? 

What about putting it on a USB Storage device and easily loading the ecrypted folder on the device?

EcryptFS Loader makes this rather simple.


## Requirements

- ubuntu 12.04 or greater (may work on earlier versions)


## How to Use

1. Install configuration ecryptfs-loader: `sudo setup.py install`

2. Create a test file:  `touch my-test.ecryptfs`

3. Call the ecryptfs-loader with create option, `ecryptfs-loader -c my-test.ecryptfs`. encfs will emit standard promprts for creating an encrypted directory. In the example below, 'p' for Paranoia mode was selected. At the end a password is requested. See SAMPLE OUTPUT 1 for an example.

4. If there are no errors, a new folder `my-test` should open. Copy some data to the folder. See SAMPLE OUTPUT 2

5. Now unmount the foler `ecryptfs-loader my-test.ecryptfs`

6. From a graphical file manager (nautilus), double-click the file my-test.ecryptfs. If it is not already assocated with ecryptfs-loader, it may open an editor. If that happens, right-click the file and get properties. From this scdialog, click the open-with tab. On that tab, select EcryptFSLoader and "Set As Default". Try double-click again.

7. A prompt for a password should appear the first time. Once entered correctly, a file browser of the encrypted directory should open.

8. On a second double-click it will unmount the directory and the files will be hidden.


### SAMPLE OUTPUT 1
```
user@localhost:~$ touch my-test.ecryptfs 
user@localhost:~$ ecryptfs-loader -c my-test.ecryptfs 
ecryptfs-loader
my-test
/home/brayra
SAFE_ENC=/home/brayra/.my-test
SAFE=/home/brayra/my-test
Will attempt to create encrypted directory
Mount Directory
The directory "/home/brayra/.my-test/" does not exist. Should it be created? (y,n) y
Creating new encrypted volume.
Please choose from one of the following options:
 enter "x" for expert configuration mode,
 enter "p" for pre-configured paranoia mode,
 anything else, or an empty line will select standard mode.
?> p

Paranoia configuration selected.

Configuration finished.  The filesystem to be created has
the following properties:
Filesystem cipher: "ssl/aes", version 3:0:2
Filename encoding: "nameio/block", version 3:0:1
Key Size: 256 bits
Block Size: 1024 bytes, including 8 byte MAC header
Each file contains 8 byte header with unique IV data.
Filenames encoded using IV chaining mode.
File data IV is chained to filename IV.
File holes passed through to ciphertext.

-------------------------- WARNING --------------------------
The external initialization-vector chaining option has been
enabled.  This option disables the use of hard links on the
filesystem. Without hard links, some programs may not work.
The programs 'mutt' and 'procmail' are known to fail.  For
more information, please see the encfs mailing list.
If you would like to choose another configuration setting,
please press CTRL-C now to abort and start over.

Now you will need to enter a password for your filesystem.
You will need to remember this password, as there is absolutely
no recovery mechanism.  However, the password can be changed
later using encfsctl.
```

### SAMPLE OUTPUT 2
```
user@localhost:~$ dpkg -l >my-test/package-listing.txt
user@localhost:~$ ls my-test
package-listing.txt
user@localhost:~$ ls .my-test/
unKTVYcWatX1MPHJOM4VuEESqdfdStCdDwkWFafajkr3T0
```

## Contributors

Richard Bray  wrote this script for, well, fun.

## License

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
 
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 

## TODO

Allow the delay setting to be added to the loader file. Maybe some other defaults. This would make it possible for the user to have some filesystems timeout in 1 minute, and others never time out. I'm thinking that encrypted directories on the local hard drive would not time out, and the USB Storage directories would time out rather quickly, 5-10 minutes. However, a high security setting would be one minute. 
