import java.util.*;

//
// A preposterously inefficient correct sorting algorithm based on Bogo-sort and 
// Collections.shuffle choking on linked lists. 

// sample output:
// for 0 items, avg of 100 runs: 0.005211529999999995ms
// for 1 items, avg of 100 runs: 0.015614510000000012ms
// for 2 items, avg of 100 runs: 0.005484309999999999ms
// for 3 items, avg of 100 runs: 0.018383879999999995ms
// for 4 items, avg of 100 runs: 0.024642720000000007ms
// for 5 items, avg of 100 runs: 0.07715626000000003ms
// for 6 items, avg of 100 runs: 0.21825682999999987ms
// for 7 items, avg of 100 runs: 0.8237080700000002ms
// for 8 items, avg of 100 runs: 6.506633649999999ms
// for 9 items, avg of 100 runs: 61.78610074ms
// for 10 items, avg of 100 runs: 575.2219407599998ms
// for 11 items, avg of 10 runs: 11888.166443900001ms
// for 12 items, avg of 10 runs: 86044.82849790002ms
// for 13 items, avg of 10 runs: 1453152.7662497996ms (~24 min)
//
// I've never seen 14 terminate. I think this is O(n^2 * n!).
//
public class Bogo {
    static void sort(List<Integer> list) {
        boolean sorted = false;

        while(!sorted) {
            Collections.shuffle(list);
            int prev = Integer.MIN_VALUE;
            int count = 0;
            for (int i : list) {
                if (prev > i) {
                    break;
                }
                prev = i;
                count++;
            }
            if (count == list.size()) {
                sorted = true;
            } 
        }
    }

    public static void main(String[] args) {
        long start;
        long stop;

        for (int i = 0, n=10; i < 20; i++){
            double sum = 0.0;
            for (int j = n; j > 0; j--) {
                List<Integer> list = new LinkedList<>();
                for (int k = 0; k < i; k++) {
                    list.add(k);
                }
                start = System.nanoTime();
                sort(list);
                stop = System.nanoTime();
                double millis = (stop-start)/1e6;
                if (n < 10)
                    System.out.println("for "+i+" items: "+test(list)+": "+millis+"ms");
                sum += millis;
            }

            System.out.println("for "+i+" items, avg of "+n+" runs: "+(sum/n*1e6/1e6)+"ms");
            if (i > 12) n = 16;
        }
    }

    private static String test(List<Integer> list) {
        int prev = Integer.MIN_VALUE;
        String listString = "{";
        for (int i : list) {
            listString += i+",";
            assert prev < i;
            prev = i;
        }
        return listString + "}";
    }
}
