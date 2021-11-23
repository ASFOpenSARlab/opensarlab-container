import pathlib
import argparse

from jinja2 import Environment, FileSystemLoader

env = Environment(
    loader=FileSystemLoader(pathlib.Path(__file__).parent),
    autoescape=True
)

def main(output_file):

    # Get all the profile directoy names under the sibling `profiles`
    profiles = [str(x) for x in pathlib.Path("./profiles/").iterdir() if x.is_dir()]

    with open(output_file, 'w') as outfile:
        template = env.get_template('templates/cf-container-profiles.yaml.jinja')
        outfile.write(template.render(profiles=profiles))

if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument('--output_file', default=None)
    args = parser.parse_args()

    main(args.output_file)
