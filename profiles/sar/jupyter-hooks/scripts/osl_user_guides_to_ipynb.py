#!/usr/bin/python

# osl_user_guides_to_ipynb.py
# Alex Lewandowski
# 10-14-20

import glob 
import os
import json
import pypandoc
import argparse

def user_guide_to_notebooks(path: str):
    guide_paths = glob.glob(f"{path}/user_docs/guides/*.md")
    guide_paths.append(glob.glob(f"{path}/user_docs/*.md")[0])

    for p in guide_paths:
        dirname = os.path.dirname(p)
        os.chdir(dirname) # must change dirs so pandoc can validate relative image paths in markdown
        ipynb = p.replace('md', 'ipynb')
        pypandoc.convert_file(p, 'ipynb', outputfile=ipynb)
        with open(ipynb, 'r') as f:
            data = json.load(f)
        with open(ipynb, 'w') as f:
            for i, line in enumerate(data['cells'][0]['source']):
                    data['cells'][0]['source'][i] = line.replace(".md", ".ipynb")
            json.dump(data, f)
        if os.path.exists(p):
            os.remove(os.path.basename(p))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="osl_user_guides_to_ipynb.py",
                                     description="Convert OpenSARlab user docs in a local asf-jupyter-docs repo from markdown to Jupyter Notebooks, and delete the markdown docs.")
    parser.add_argument("-p", "--path", type=str ,help="Path to local asf-jupyter-docs repository", default="/home/jovyan/asf-jupyter-docs/")
    args = parser.parse_args()
    user_guide_to_notebooks(args.path)