# Compliance 

Compliance is an open source ruby script which produce html pages from csv file; it is strictly used to produce pages for the chouette validation tests descriptioon


Requirements
------------

This code has been run with :
* Ruby 1.9.3

External Deps
-------------

On Debian/Ubuntu/Kubuntu OS : assume depot contains the correct version
```sh
sudo apt-get install ruby
```

Installation
------------

Get git source code :
```sh
cd workspace
git clone -b V2_2 git://github.com/afimb/compliance
cd compliance
```

Configuration
-------------

Configure css.
* adapt compliance.css for your own look

Configure html (utf-8 encoded files).
* adapt template.html for your own use 
** %{cn} is replaced by the content of column n in csv (n start with value 0)
** htm file will be named %{c0}.html
* adapt index.html for index page
** %{entries} wil be replaced by a bloc for each row in csv
** bloc template is define in toc_entries.html
* adapt toc_entries.html for table of content in index.html 
** %{cn} is replaced by the content of column n in csv (n start with value 0)

Run
---

Export csv data with all strings between " and use comma as separator
```sh
./compliance.rb [file.csv]
```
This script will produce a zip with the css and all test pages in file.zip


More Information
----------------

More information can be found on the [project website on GitHub](.).
There is extensive usage documentation available [on the wiki](../../wiki).

License
-------

This project is licensed under the CeCILL-B license, a copy of which can be found in the [LICENSE](./LICENSE.md) file.

Release Notes
-------------

The release notes can be found in [CHANGELOG](./CHANGELOG.md) file

Support
-------

Users looking for support should file an issue on the GitHub [issue tracking page](../../issues), or file a [pull request](../../pulls) if you have a fix available.
