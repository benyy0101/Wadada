package org.api.wadada.common.enums;

public enum DefaultImage {
    DEFAULT_IMAGE("https://andyimagebucket.s3.ap-northeast-2.amazonaws.com/testPath/com/a102/andy/cat2024-03-13T10%3A47%3A09.786806600.png");

    private final String defaultImageUri;

    DefaultImage(String defaultImageUri) {
        this.defaultImageUri = defaultImageUri;
    }

    public String getDefaultImageUri() {
        return defaultImageUri;
    }
}
