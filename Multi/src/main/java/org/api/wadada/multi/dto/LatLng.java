package org.api.wadada.multi.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LatLng {

    private double latitude;
    private double longitude;

    // 생성자
    public LatLng(double latitude, double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }
    public double getX(){
        return this.latitude;
    }
    public double getY(){
        return this.longitude;
    }

    public double distanceTo(LatLng another) {
        return Math.sqrt(Math.pow(this.latitude - another.latitude, 2) + Math.pow(this.longitude - another.longitude, 2));
    }

}
