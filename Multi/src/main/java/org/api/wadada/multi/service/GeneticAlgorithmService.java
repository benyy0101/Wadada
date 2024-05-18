package org.api.wadada.multi.service;

import org.api.wadada.multi.dto.LatLng;
import org.api.wadada.multi.dto.res.FlagPointRes;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@Service
public class GeneticAlgorithmService {
    private static final int POPULATION_SIZE = 100;
    private static final int GENERATIONS = 100;
    private static final double MUTATION_RATE = 0.01;
    private static final double CROSSOVER_RATE = 0.9;
    private static final double R = 6371.0;

    private double haversineDistance(LatLng p1, LatLng p2) {
        double lat1 = p1.getLatitude(), lon1 = p1.getLongitude();
        double lat2 = p2.getLatitude(), lon2 = p2.getLongitude();
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    private double fitness(LatLng individual, List<LatLng> points, int dist) {
        double penalty = 0;
        double totalDistance = 0;
        for (LatLng point : points) {
            double distance = haversineDistance(individual, point);
            totalDistance += distance;
            if (distance < dist - 0.15 || distance > dist + 0.15) {
                penalty += 100000000;
            }
        }
        return totalDistance / points.size() + penalty;
    }

    private LatLng crossover(LatLng parent1, LatLng parent2) {
        Random rand = new Random();
        if (rand.nextDouble() < CROSSOVER_RATE) {
            double lat = (parent1.getLatitude() + parent2.getLatitude()) / 2;
            double lng = (parent1.getLongitude() + parent2.getLongitude()) / 2;
            return new LatLng(lat, lng);
        }
        return rand.nextBoolean() ? parent1 : parent2;
    }

    private void mutate(LatLng individual) {
        Random rand = new Random();
        if (rand.nextDouble() < MUTATION_RATE) {
            individual.setLatitude(individual.getLatitude() + rand.nextGaussian() * 0.01);
            individual.setLongitude(individual.getLongitude() + rand.nextGaussian() * 0.01);
        }
    }


    private LatLng select(List<LatLng> population, List<LatLng> points, int dist) {
        Random rand = new Random();
        LatLng best = population.get(rand.nextInt(population.size()));
        double bestFitness = fitness(best, points, dist);

        for (int i = 0; i < 10; i++) { // Tournament selection
            int idx = rand.nextInt(population.size());
            LatLng individual = population.get(idx);
            double indFitness = fitness(individual, points,dist);
            if (indFitness < bestFitness) {
                best = individual;
                bestFitness = indFitness;
            }
        }
        return best;
    }


    // 최대 최소 설정
    public FlagPointRes findOptimalPoint(List<LatLng> points, int dist) {
        List<LatLng> population = new ArrayList<>();
        Random rand = new Random();
        for (int i = 0; i < POPULATION_SIZE; i++) {
            LatLng individual = new LatLng(
                    36.0 + (38.0 - 36.0) * rand.nextDouble(),
                    126.0 + (130.0 - 126.0) * rand.nextDouble()
            );
            population.add(individual);
        }

        LatLng bestIndividual = null;
        double bestFitness = Double.MAX_VALUE;

        for (int gen = 0; gen < GENERATIONS; gen++) {
            List<LatLng> newPopulation = new ArrayList<>();
            for (int i = 0; i < POPULATION_SIZE; i++) {
                LatLng parent1 = select(population, points, dist);
                LatLng parent2 = select(population, points, dist);
                LatLng child = crossover(parent1, parent2);
                mutate(child);
                newPopulation.add(child);
            }
            population = newPopulation;

            for (LatLng individual : population) {
                double currentFitness = fitness(individual, points, dist);
                if (currentFitness < bestFitness) {
                    bestIndividual = individual;
                    bestFitness = currentFitness;
                }
            }
        }

        assert bestIndividual != null;
        return FlagPointRes.builder().latitude(bestIndividual.getLatitude()).longitude(bestIndividual.getLongitude()).build();
    }
}