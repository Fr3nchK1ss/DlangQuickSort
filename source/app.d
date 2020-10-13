import std.stdio : writeln;
import std.algorithm.sorting;

///First approach
pure void quickSort(T) (T[] r)
{
  if (r.length > 1)
  {
    size_t p = pivotPartition(r, r.length-1);  //r[$-1] is swapped to r[p]

    quickSort( r[ 0..p ] );
    quickSort( r[ p+1..$ ] );
  }
}

void main()
{
  int[] arr = [9,7, 4 , 8, 5, 3, 1];
  quickSort!(int)(arr);
  writeln("arr : ", arr );

}
