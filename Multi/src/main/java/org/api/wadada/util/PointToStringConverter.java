//package org.api.wadada.util;
//
//
//import jakarta.persistence.AttributeConverter;
//import jakarta.persistence.Converter;
//import org.locationtech.jts.geom.Point;
//import org.locationtech.jts.io.WKTReader;
//import org.locationtech.jts.io.WKTWriter;
//
//@Converter(autoApply = true)
//public class PointToStringConverter implements AttributeConverter<Point, String> {
//
//    @Override
//    public String convertToDatabaseColumn(Point attribute) {
//        if (attribute == null) {
//            return null;
//        }
//        return new WKTWriter().write(attribute);
//    }
//
//    @Override
//    public Point convertToEntityAttribute(String dbData) {
//        if (dbData == null) {
//            return null;
//        }
//        try {
//            return (Point) new WKTReader().read(dbData);
//        } catch (Exception e) {
//            throw new RuntimeException("Failed to convert String to Point.", e);
//        }
//    }
//}
