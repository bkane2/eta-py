# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html
#
# NOTE: see this project for additional information:
# https://github.com/JamesALeedham/Sphinx-Autosummary-Recursion/blob/master/docs/conf.py

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'eta-py'
copyright = '2023, Benjamin Kane'
author = 'Benjamin Kane'
release = '1.0.0'

import os
import sys
sys.path.insert(0, os.path.abspath('..'))

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
  'sphinx.ext.autodoc',
  'sphinx.ext.autosummary',
  'sphinx.ext.coverage',
  'sphinx.ext.intersphinx',
  'sphinx.ext.viewcode',
  'sphinx_autodoc_typehints',
  'sphinx.ext.napoleon',
  # 'autoapi.extension'
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

intersphinx_mapping = {
    "python": ("https://docs.python.org/3/", None),
}

# autoapi_dirs = ['eta']

autodoc_member_order = 'bysource'
autodoc_default_options = {
    'members': True,
    'show-inheritance': True,
}
autodoc_inherit_docstrings = True
autosummary_generate = True
autoclass_content = "both"

add_module_names = False

set_type_checking_flag = True

html_show_sourcelink = False

templates_path = ['_templates']
source_suffix = '.rst'
master_doc = 'index'



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

# html_theme = 'alabaster'
html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']

def setup(app):
  app.add_css_file('my_theme.css')
