oVMimage
================
A script to extract infromation about instances (servers) from an OpenStack cluster.<br/>

## Copyright
Copyright (c) 2020 Marco Napolitano<br/>
The author is Marco Napolitano, email: mannysys-AaaaT-outlook.com put at sign instead of -AaaaT-<br/>
The content of the repository is licensed under Apache License, available at: http://www.apache.org/licenses/LICENSE-2.0

## Disclaimer
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Description
This repository contains a script made to extract infromation about instances (servers) from an OpenStack cluster.<br/>
It is a custom script, made for a custom OpenStack architecture, where Nova ephemeral disks of instances are mounted from a nfs share,
which is the same nfs share mounted on all the compute nodes of the cluster.<br/>
In order to extract data, the script calls ssh in order to connect to one of the compute nodes, and calls openstack cli from the host where it is run.<br/>
The output of the script is a csv file, so it can also be imported into a spreadsheet for further elaboration.<br/>
There is an example csv extraction file in the repository.<br/>
