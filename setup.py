from setuptools import setup
import os


def read_file(name):
    with open(os.path.join(os.path.dirname(__file__), name)) as f:
        return f.read()


version = '1.0a1.dev0'
shortdesc = "Create development environments with a set of source packages."
longdesc = '\n\n'.join([read_file(name) for name in [
    'README.rst',
    'CHANGES.rst',
    'LICENSE.rst'
]])


setup(
    name='mxenv',
    version=version,
    description=shortdesc,
    long_description=longdesc,
    classifiers=[
        'License :: OSI Approved :: BSD License',
        'Intended Audience :: Developers',
        'Topic :: Software Development',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
    ],
    keywords='development environment',
    author='Cone Contributors',
    author_email='dev@conestack.org',
    url='http://github.com/conestack/mxenv',
    license='Simplified BSD',
    py_packages=['mxenv'],
    test_suite='mxenv.tests',
    zip_safe=False,
    include_package_data=True,
    install_requires=[
        'Jinja2',
        'mxdev',
        'setuptools'
    ],
    extras_require=dict(
        docs=[
            'Sphinx',
            'sphinx-conestack-theme'
        ]
    ),
    entry_points=dict(
        console_scripts=['mxenv = mxenv.main:main'],
        mxdev=['hook = mxenv.hook:Hook']
    )
)
