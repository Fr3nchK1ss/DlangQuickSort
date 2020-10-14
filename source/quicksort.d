/**
 This module implements various quicksort functions
 Use 'dub test' for unittest.

 Authors: ludo456 (on github)
 */

import std.stdio : writeln;
import std.algorithm.sorting;

/**
  First approach, using plain slices

 */
pure void quickSort1(T) (T[] r)
{
  if (r.length > 1)
  {
    //using pivotPartition from std
    size_t p = pivotPartition(r, r.length-1);  //r[$-1] is swapped to r[p]
    //p is the index of the pivot whose value is r[$-1]

    //quickSort partitions
    quickSort1( r[ 0..p ] );
    quickSort1( r[ p+1..$ ] );
  }
}

/// quickSort1
unittest
{
  int[] arr = [9,7, 4 , 8, 5, 3, 1];
  //writeln("Starting arr : ", arr );

  quickSort1!(int)(arr);
  //writeln("QS1 - Sorted arr : ", arr );

  //Or even (contrib Ali Çehreli)
  int[] arr2 = [9,7, 4 , 8, 5, 3, 1];
  quickSort1(arr2);//int type deduction!
  writeln("QS1 - Sorted arr (type deduction): ", arr2 );

  assert (arr == [1, 3, 4, 5, 7, 8, 9]);
  assert (arr2 == arr);
}


/**
  Second approach, (contrib Ali Çehreli)

  The first version can not work on RandomAccessRanges.
  In order to make it work, we remove the brackets from the parameter list.
  But that would mean quickSort2 can accept any parameter, compiler would not
  complain but running would crash.
  So we use a template constraint (contrib S. Schveighoffer), copy-pasted
  from the constraints of std.algo.pivotPartition()
 */

import std.range;

pure void quickSort2(Range) (Range r)
if (isRandomAccessRange!Range
  && hasLength!Range
  && hasSlicing!Range
  && hasAssignableElements!Range)
{
  if (r.length > 1)
  {
    //using pivotPartition from std
    size_t p = pivotPartition(r, r.length-1);  //r[$-1] is swapped to r[p]
    //p is the index of the pivot whose value is r[$-1]

    //quickSort partitions
    quickSort2( r[ 0..p ] );
    quickSort2( r[ p+1..$ ] );
  }
}

/// quickSort2
unittest
{
  int[] arr = [9,7, 4 , 8, 5, 3, 1];
  int[] arr2 = [ 11, 10];

  quickSort2(chain(arr, arr2));
  writeln("QS2 - Sorted arr : ", arr );
  writeln("QS2 - Sorted arr2 : ", arr2 );

  assert (arr == [1, 3, 4, 5, 7, 8, 9]);
  assert (arr2 == [10, 11]);
}


/**
  Third example, from https://garden.dlang.io/#quicksort

  This implementation returns the sorted array.
  */
import std.algorithm: filter;
import std.array: array;

int[] quickSort3(int[] arr)
{
  if(!arr.length) return [];
  if(arr.length == 1) return arr;

  //For no particular reason, arr[0] is taken as pivot
  return
    quickSort3( arr.filter!(a => a < arr[0]).array ) ~
    arr[0] ~
    quickSort3( arr[1..$].filter!(a => a >= arr[0]).array );

}

/// quickSort3
unittest
{
  int[] arr = [9,7, 4 , 8, 5, 3, 1];

  int[] res = quickSort3(arr);
  writeln("QS3 - Sorted arr : ", res );

  assert (res == [1, 3, 4, 5, 7, 8, 9]);
}
