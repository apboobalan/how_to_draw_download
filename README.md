#### Crawl and download images in a page.

- Get all links which has images from a home page.
- From the links get links of images.(Executed parallelly)
- Save images.(Executed sequentially since parallel execution threw handshake error.
- Redirection to com url from .co.uk url is done because some images are in com domain and co.uk domains contain redirections.
- some custom string replacements are done.

*Replace URL to use in a page*

