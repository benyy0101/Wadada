package org.api.wadada.common.enums;

public enum DefaultImage {
    DEFAULT_IMAGE("");

    private final String defaultImageUri;

    DefaultImage(String defaultImageUri) {
        this.defaultImageUri = defaultImageUri;
    }

    public String getDefaultImageUri() {
        return defaultImageUri;
    }
}
