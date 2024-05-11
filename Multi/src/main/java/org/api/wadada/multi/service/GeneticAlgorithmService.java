package org.api.wadada.multi.service;

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
    private static final double TARGET_DISTANCE = 3.0;
    private static final double R = 6371.0;

    private double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    private double fitness(double[] individual, double[][] points) {
        double penalty = 0;
        double totalDistance = 0;
        for (double[] point : points) {
            double distance = haversineDistance(individual[0], individual[1], point[0], point[1]);
            totalDistance += distance;
            if (distance < TARGET_DISTANCE - 0.5 || distance > TARGET_DISTANCE + 0.5) {
                penalty += 100000000;
            }
        }
        return totalDistance / points.length + penalty;
    }

    private double[] crossover(double[] parent1, double[] parent2) {
        Random rand = new Random();
        if (rand.nextDouble() < CROSSOVER_RATE) {
            double[] child = new double[2];
            child[0] = (parent1[0] + parent2[0]) / 2;
            child[1] = (parent1[1] + parent2[1]) / 2;
            return child;
        }
        return rand.nextBoolean() ? parent1 : parent2;
    }

    private void mutate(double[] individual) {
        Random rand = new Random();
        if (rand.nextDouble() < MUTATION_RATE) {
            individual[0] += rand.nextGaussian() * 0.01;
            individual[1] += rand.nextGaussian() * 0.01;
        }
    }

    private double[] select(List<double[]> population, double[][] points) {
        Random rand = new Random();
        double[] best = population.get(rand.nextInt(population.size()));
        double bestFitness = fitness(best, points);

        for (int i = 0; i < 10; i++) { // Tournament selection
            int idx = rand.nextInt(population.size());
            double[] individual = population.get(idx);
            double indFitness = fitness(individual, points);
            if (indFitness < bestFitness) {
                best = individual;
                bestFitness = indFitness;
            }
        }
        return best;
    }

    public FlagPointRes findOptimalPoint(double[][] points) {
        List<double[]> population = new ArrayList<>();
        Random rand = new Random();
        for (int i = 0; i < POPULATION_SIZE; i++) {
            double[] individual = {
                    36.0 + (38.0 - 36.0) * rand.nextDouble(),
                    126.0 + (130.0 - 126.0) * rand.nextDouble()
            };
            population.add(individual);
        }

        double[] bestIndividual = null;
        double bestFitness = Double.MAX_VALUE;

        for (int gen = 0; gen < GENERATIONS; gen++) {
            List<double[]> newPopulation = new ArrayList<>();
            for (int i = 0; i < POPULATION_SIZE; i++) {
                double[] parent1 = select(population, points);
                double[] parent2 = select(population, points);
                double[] child = crossover(parent1, parent2);
                mutate(child);
                newPopulation.add(child);
            }
            population = newPopulation;

            for (double[] individual : population) {
                double currentFitness = fitness(individual, points);
                if (currentFitness < bestFitness) {
                    bestIndividual = individual;
                    bestFitness = currentFitness;
                }
            }
        }

//        return bestIndividual;
        assert bestIndividual != null;
        return FlagPointRes.builder().latitude(bestIndividual[0]).longitude(bestIndividual[1]).build();

    }
}