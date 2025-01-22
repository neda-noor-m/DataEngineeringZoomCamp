<h1>Question 1. Understanding docker first run</h1>
Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash. <br>
<br>
What's the version of pip in the image?

- 24.3.1<br>
- 24.2.1<br>
- 23.3.1<br>
- 23.2.1

```python
#code
(base) neda@taxi-rides-vm:~$ sudo docker run -it python:3.12.8 bash
root@c553063c0be6:/# pip --version
pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
```
