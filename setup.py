from setuptools import find_packages, setup

setup(
    name="docker_all_the_way",
    version="0.1.0",
    description="Just a sample project",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    install_requires=["tornado~=6.1", "psycopg2-binary~=2.9.3"],
    entry_points={"console_scripts": ["serve_app=app.main:main"]},
)
