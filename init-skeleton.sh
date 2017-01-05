#!/bin/sh

# The MIT License
#
# Copyright (c) 2016,2017 Jérémie DECOCK <jd.jdhp@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# SAFETY TESTS ################################################################

# TODO: assert "$(dirname "$0") == "$(pwd)"
#       ...


# LOAD VARIABLES ##############################################################

. ./meta.sh

echo "AUTHOR_NAME: ${AUTHOR_NAME}"
echo "AUTHOR_EMAIL: ${AUTHOR_EMAIL}"
echo "AUTHOR_WEB_SITE: ${AUTHOR_WEB_SITE}"
echo "COPYRIGHT_NOTICE: ${COPYRIGHT_NOTICE}"
echo "DOCUMENT_DATE: ${DOCUMENT_DATE}"
echo "INSTITUTE: ${INSTITUTE}"
echo "DOCUMENT_SUBJECT: ${DOCUMENT_SUBJECT}"
echo "DOCUMENT_KEYWORDS: ${DOCUMENT_KEYWORDS}"
echo "DOCUMENT_TITLE: ${DOCUMENT_TITLE}"
echo "DOCUMENT_SUBTITLE: ${DOCUMENT_SUBTITLE}"
echo "DOCUMENT_FILE_BASE_NAME: ${DOCUMENT_FILE_BASE_NAME}"
echo "DOCUMENT_WEB_SITE_URL: ${DOCUMENT_WEB_SITE_URL}"
echo "DOCUMENT_HTML_URL: ${DOCUMENT_HTML_URL}"
echo "DOCUMENT_PDF_URL: ${DOCUMENT_PDF_URL}"
echo "DOCUMENT_GIT_FORGE_ACCOUNT: ${DOCUMENT_GIT_FORGE_ACCOUNT}"
echo "DOCUMENT_GIT_FORGE_REPOSITORY_NAME: ${DOCUMENT_GIT_FORGE_REPOSITORY_NAME}"
echo "DOCUMENT_GIT_FORGE_URL ${DOCUMENT_GIT_FORGE_URL}"
echo "DOCUMENT_GIT_FORGE_PROJECT_URL ${DOCUMENT_GIT_FORGE_PROJECT_URL}"
echo "DOCUMENT_ISSUE_TRACKER_URL: ${DOCUMENT_ISSUE_TRACKER_URL}"
echo "HTML_TMP_DIR: ${HTML_TMP_DIR}"


# SETUP GIT ###################################################################

git remote rename origin skeleton
git remote add origin git@${DOCUMENT_GIT_FORGE_DOMAIN}:${DOCUMENT_GIT_FORGE_ACCOUNT}/${DOCUMENT_GIT_FORGE_REPOSITORY_NAME}.git
git push -u origin french-version

git submodule init
git submodule update


# MAKE SUBSTITUTIONS ##########################################################

sed -i "" \
    -e "s/TODO_AUTHOR_NAME/${AUTHOR_NAME}/g" \
    -e "s/TODO_AUTHOR_EMAIL/${AUTHOR_EMAIL}/g" \
    -e "s TODO_AUTHOR_WEB_SITE ${AUTHOR_WEB_SITE} g" \
    -e "s|TODO_COPYRIGHT_NOTICE|${COPYRIGHT_NOTICE}|g" \
    -e "s|TODO_DOCUMENT_DATE|${DOCUMENT_DATE}|g" \
    -e "s|TODO_INSTITUTE|${INSTITUTE}|g" \
    -e "s|TODO_DOCUMENT_SUBJECT|${DOCUMENT_SUBJECT}|g" \
    -e "s|TODO_DOCUMENT_KEYWORDS|${DOCUMENT_KEYWORDS}|g" \
    -e "s;TODO_DOCUMENT_TITLE;${DOCUMENT_TITLE};g" \
    -e "s;TODO_DOCUMENT_SUBTITLE;${DOCUMENT_SUBTITLE};g" \
    -e "s/TODO_DOCUMENT_FILE_BASE_NAME/${DOCUMENT_FILE_BASE_NAME}/g" \
    -e "s TODO_DOCUMENT_WEB_SITE_URL ${DOCUMENT_WEB_SITE_URL} g" \
    -e "s TODO_DOCUMENT_HTML_URL ${DOCUMENT_HTML_URL} g" \
    -e "s TODO_DOCUMENT_PDF_URL ${DOCUMENT_PDF_URL} g" \
    -e "s/TODO_DOCUMENT_GIT_FORGE_ACCOUNT/${DOCUMENT_GIT_FORGE_ACCOUNT}/g" \
    -e "s/TODO_DOCUMENT_GIT_FORGE_REPOSITORY_NAME/${DOCUMENT_GIT_FORGE_REPOSITORY_NAME}/g" \
    -e "s TODO_DOCUMENT_GIT_FORGE_URL ${DOCUMENT_GIT_FORGE_URL} g" \
    -e "s TODO_DOCUMENT_GIT_FORGE_PROJECT_URL ${DOCUMENT_GIT_FORGE_PROJECT_URL} g" \
    -e "s TODO_DOCUMENT_ISSUE_TRACKER_URL ${DOCUMENT_ISSUE_TRACKER_URL} g" \
    -e "s/TODO_HTML_TMP_DIR/${HTML_TMP_DIR}/g" \
    AUTHORS \
    meta.make \
    README.rst \
    .gitignore \
    main.rst \
    meta.rst


# FIX TITLES UNDERLINE LENGTH IN RESTRUCTUREDTEXT FILES #######################

DOCUMENT_TITLE_UNDERLINE=$(echo "${DOCUMENT_TITLE}" | tr '[:print:]' '=')

sed -i "" \
    -e "s/^====$/${DOCUMENT_TITLE_UNDERLINE}/" \
    README.rst

sed -i "" \
    -e "s/^====$/${DOCUMENT_TITLE_UNDERLINE}/" \
    main.rst

