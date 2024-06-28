import 'dart:core';
import 'dart:io';
import 'dart:math';


import 'Result.dart';

class Sort_Nhonn {
  void Selection_Sort(List<int> list, int start, int end){
    for (int i = 0; i <= end; i++)
    {
      int check = i;
      for (int j = i + 1; j <= end; j++)
        if (list[j] < list[check])
          check = j;

      int temp = list[check];
      list[check] = list[i];
      list[i] = temp;
    }
  }

  void Quick_Sort(List<int> vec, int start, int end) {
    if (start < end) {
      int pi = Part(vec, start, end);
      Quick_Sort(vec, start, pi - 1);
      Quick_Sort(vec, pi + 1, end);
    }
  }

  int Part(List<int> vec, int start, int end) {
    int pivot = vec[end];
    int i = start - 1;

    for (int j = start; j <= end - 1; j++) {
      if (vec[j] < pivot) {
        i++;
        swap(vec, i, j);
      }
    }
    swap(vec, i + 1, end);
    return (i + 1);
  }

  void swap(List<int> vec, int i, int j) {
    int temp = vec[i];
    vec[i] = vec[j];
    vec[j] = temp;
  }

  void Pigeonhole_Sort(List<int> list, int start, int end) {
    int min = list[start];
    int max = list[start];
    for (int i = start + 1; i <= end; i++) {
      if (list[i] < min) {
        min = list[i];
      }
      if (list[i] > max) {
        max = list[i];
      }
    }

    int range = max - min + 1;
    List<List<int>> holes = List.generate(range, (_) => []);

    for (int i = start; i <= end; i++) {
      holes[list[i] - min].add(list[i]);
    }

    int index = start;
    for (int i = 0; i < range; i++) {
      for (int j = 0; j < holes[i].length; j++) {
        list[index] = holes[i][j];
        index++;
      }
    }
  }

  void Flash_Sort(List<int> list, int start, int end) {
    int n = end - start + 1;
    if (n < 2) return;

    int m = (0.2 * n).toInt();

    int min = list[start], max = list[start];
    for (int i = start + 1; i <= end; i++) {
      if (list[i] < min) min = list[i];
      if (list[i] > max) max = list[i];
    }

    if (min == max) return;

    List<int> count = List<int>.filled(m, 0);

    double c1 = (m - 1) / (max - min);
    for (int i = start; i <= end; i++) {
      int k = ((list[i] - min) * c1).toInt();
      count[k]++;
    }

    for (int i = 1; i < m; i++) {
      count[i] += count[i - 1];
    }

    List<int> copy = List<int>.from(list);

    for (int i = end; i >= start; i--) {
      int k = ((copy[i] - min) * c1).toInt();
      list[start + --count[k]] = copy[i];
    }

    for (int i = 0; i < m - 1; i++) {
      int from = start + count[i];
      int to = start + count[i + 1] - 1;
      if (from < to) {
        _insertionSort_n(list, from, to);
      }
    }

    _insertionSort_n(list, start + count[m - 1], end);
  }

  void _insertionSort_n(List<int> arr, int start, int end) {
    for (int i = start + 1; i <= end; i++) {
      int key = arr[i];
      int j = i - 1;
      while (j >= start && arr[j] > key) {
        arr[j + 1] = arr[j];
        j--;
      }
      arr[j + 1] = key;
    }
  }




  // ----------------------PHUC------------------------
  // INSERT SORT
  void Insertion_Sort(List<int> list, int start, int end)
  {
    for (int i = start + 1; i <= end; i++)
    {
      int key = list[i]; // Phần tử hiện tại để chèn
      int j = i - 1;

      // Di chuyển các phần tử của list[0..i-1] lớn hơn key
      // đến vị trí trước vị trí hiện tại
      while (j >= start && list[j] > key)
      {
        list[j + 1] = list[j];
        j--;
      }
      list[j + 1] = key; // Chèn key vào vị trí đã tìm được
    }
  }

  // COCKTAIL SORT
  void Cocktail_Shaker_Sort(List<int> list, int start, int end)
  {
    bool swapped = true; // Biến để kiểm tra có sự hoán đổi nào không
    while (swapped)
    {
      swapped = false;

      // Di chuyển từ trái sang phải
      for (int i = start; i < end; i++)
      {
        if (list[i] > list[i + 1])
        {
          int temp = list[i];
          list[i] = list[i + 1];
          list[i + 1] = temp;
          swapped = true;
        }
      }

      if (!swapped) // Nếu không có hoán đổi, mảng đã được sắp xếp
        break;

      swapped = false;
      end--; // Giảm end vì phần tử cuối cùng đã đúng vị trí

      // Di chuyển từ phải sang trái
      for (int i = end - 1; i >= start; i--)
      {
        if (list[i] > list[i + 1])
        {
          int temp = list[i];
          list[i] = list[i + 1];
          list[i + 1] = temp;
          swapped = true;
        }
      }
      start++; // Tăng start vì phần tử đầu tiên đã đúng vị trí
    }
  }


  // HEAP SORT
  void Heap_Sort(List<int> list, int start, int end) {
    int n = end - start + 1;

    // Xây dựng max heap
    for (int i = n ~/ 2 - 1; i >= 0; i--) {
      heapify(list, n, i, start);
    }

    // Trích xuất lần lượt các phần tử từ max heap
    for (int i = n - 1; i > 0; i--) {
      // Di chuyển phần tử lớn nhất (gốc heap) vào cuối mảng chưa sắp xếp
      int temp = list[start];
      list[start] = list[start + i];
      list[start + i] = temp;

      // Tái cấu trúc max heap trên mảng đã sắp xếp (loại bỏ phần tử cuối đã sắp xếp)
      heapify(list, i, 0, start);
    }
  }

  void heapify(List<int> list, int n, int i, int start) {
    int largest = i;  // Khởi tạo largest là nút hiện tại
    int left = 2 * i + 1;  // Chỉ mục của nút con trái
    int right = 2 * i + 2;  // Chỉ mục của nút con phải

    // Nếu nút con trái lớn hơn nút hiện tại
    if (left < n && list[start + left] > list[start + largest]) {
      largest = left;
    }

    // Nếu nút con phải lớn hơn nút hiện tại
    if (right < n && list[start + right] > list[start + largest]) {
      largest = right;
    }

    // Nếu largest không phải là nút hiện tại
    if (largest != i) {
      // Hoán đổi nút hiện tại với nút lớn nhất
      int temp = list[start + i];
      list[start + i] = list[start + largest];
      list[start + largest] = temp;

      // Đệ quy để tái cấu trúc max heap trên cây con bị ảnh hưởng
      heapify(list, n, largest, start);
    }
  }

  // TIM SORT
  void TimSort(List<int> list, int start, int end) {
    int n = end - start + 1;

    // Sắp xếp các đoạn nhỏ bằng Insertion Sort
    for (int i = start; i <= end; i += 32) {
      _insertionSort_Phuc(list, i, min(i + 32 - 1, end));
    }

    // Hợp nhất các đoạn đã sắp xếp
    for (int size = 32; size < n; size = 2 * size) {
      for (int left = start; left <= end; left += 2 * size) {
        int mid = left + size - 1;
        int right = min(left + 2 * size - 1, end);

        // Chỉ hợp nhất nếu mid < right
        if (mid < right) {
          _merge_Phuc(list, left, mid, right);
        }
      }
    }
  }

  // Insertion Sort để sắp xếp các đoạn nhỏ
  void _insertionSort_Phuc(List<int> list, int left, int right) {
    for (int i = left + 1; i <= right; i++) {
      int key = list[i];
      int j = i - 1;
      // Dịch chuyển các phần tử lớn hơn key về phía sau
      while (j >= left && list[j] > key) {
        list[j + 1] = list[j];
        j--;
      }
      // Chèn key vào vị trí đúng
      list[j + 1] = key;
    }
  }

  // Hợp nhất hai đoạn đã sắp xếp
  void _merge_Phuc(List<int> list, int left, int mid, int right) {
    int len1 = mid - left + 1;
    int len2 = right - mid;

    // Tạo các mảng tạm thời để lưu hai đoạn
    List<int> leftArr = List.filled(len1, 0);
    List<int> rightArr = List.filled(len2, 0);

    for (int x = 0; x < len1; x++) {
      leftArr[x] = list[left + x];
    }
    for (int x = 0; x < len2; x++) {
      rightArr[x] = list[mid + 1 + x];
    }

    int i = 0, j = 0, k = left;

    // Hợp nhất các mảng tạm thời vào danh sách gốc
    while (i < len1 && j < len2) {
      if (leftArr[i] <= rightArr[j]) {
        list[k] = leftArr[i];
        i++;
      } else {
        list[k] = rightArr[j];
        j++;
      }
      k++;
    }

    // Sao chép các phần tử còn lại của leftArr, nếu có
    while (i < len1) {
      list[k] = leftArr[i];
      i++;
      k++;
    }

    // Sao chép các phần tử còn lại của rightArr, nếu có
    while (j < len2) {
      list[k] = rightArr[j];
      j++;
      k++;
    }
  }

  // RADIX SORT
  void radixSort(List<int> list, int start, int end) {
    int n = end - start + 1;
    int max = getMax(list, start, end);

    for (int exp = 1; max ~/ exp > 0; exp *= 10) {
      countSort(list, start, end, exp);
    }
  }

  int getMax(List<int> list, int start, int end) {
    int max = list[start];
    for (int i = start + 1; i <= end; i++) {
      if (list[i] > max) {
        max = list[i];
      }
    }
    return max;
  }

  void countSort(List<int> list, int start, int end, int exp) {
    int n = end - start + 1;
    List<int> output = List<int>.filled(n, 0);
    List<int> count = List<int>.filled(10, 0);

    for (int i = 0; i < 10; i++) {
      count[i] = 0;
    }

    for (int i = start; i <= end; i++) {
      int index = (list[i] ~/ exp) % 10;
      count[index]++;
    }

    for (int i = 1; i < 10; i++) {
      count[i] += count[i - 1];
    }

    for (int i = end; i >= start; i--) {
      int index = (list[i] ~/ exp) % 10;
      output[count[index] - 1] = list[i];
      count[index]--;
    }

    for (int i = 0; i < n; i++) {
      list[start + i] = output[i];
    }
  }

  // COUNTING SORT
  void Counting_Sort(List<int> list, int start, int end)
  {
    int n = end - start + 1;
    int max = list[start];
    int min = list[start];

    // Tìm giá trị lớn nhất và nhỏ nhất trong danh sách
    for (int i = start + 1; i <= end; i++)
    {
      if (list[i] > max) max = list[i];
      if (list[i] < min) min = list[i];
    }

    int range = max - min + 1;
    List<int> count = List<int>.filled(range, 0);
    List<int> output = List<int>.filled(n, 0);

    // Khởi tạo mảng đếm
    for (int i = 0; i < range; i++)
    {
      count[i] = 0;
    }

    // Đếm số lần xuất hiện của mỗi phần tử
    for (int i = start; i <= end; i++)
    {
      count[list[i] - min]++;
    }

    // Cộng dồn các giá trị để tính vị trí thực tế
    for (int i = 1; i < range; i++)
    {
      count[i] += count[i - 1];
    }

    // Xây dựng mảng kết quả
    for (int i = end; i >= start; i--)
    {
      output[count[list[i] - min] - 1] = list[i];
      count[list[i] - min]--;
    }

    // Sao chép mảng kết quả vào danh sách gốc
    for (int i = 0; i < n; i++)
    {
      list[start + i] = output[i];
    }
  }




  // ----------------------Quan------------------------
  // BUBBLE SORT
  void Bubble_Sort(List<int> list, int start, int end) {
    for (int i = start; i <= end - 1; i++) {
      for (int j = start; j < end - (i - start); j++) {
        if (list[j] > list[j + 1]) {
          int temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      }
    }
  }


  // GNOME SORT
  void Gnome_Sort(List<int> list, int start, int end)
  {
    int index = start;

    while (index <= end) {
      if (index == start) {
        index++;
      } else if (index > start && list[index] >= list[index - 1]) {
        index++;
      } else {
        int temp = list[index];
        list[index] = list[index - 1];
        list[index - 1] = temp;
        index--;
        if (index < start) {
          index = start;
        }
      }
    }
  }




  // BUCKET SORT
  void bucketSort(List<int> list, int start, int end) {
    if (start >= end) {
      return;
    }

    // Tìm giá trị lớn nhất và nhỏ nhất trong đoạn cần sắp xếp
    int minValue = list[start];
    int maxValue = list[start];
    for (int i = start + 1; i <= end; i++) {
      if (list[i] < minValue) {
        minValue = list[i];
      } else if (list[i] > maxValue) {
        maxValue = list[i];
      }
    }

    // Tạo các bucket
    int bucketCount = maxValue - minValue + 1;
    List<List<int>> buckets = List<List<int>>.generate(bucketCount, (_) => []);

    // Phân phối các phần tử vào các bucket
    for (int i = start; i <= end; i++) {
      int bucketIndex = list[i] - minValue;
      buckets[bucketIndex].add(list[i]);
    }

    // Sắp xếp các phần tử trong mỗi bucket và ghép lại thành danh sách đã sắp xếp
    int currentIndex = start;
    for (int i = 0; i < bucketCount; i++) {
      if (buckets[i].isNotEmpty) {
        Insertion_Sort_Quan(buckets[i]);
        for (int item in buckets[i]) {
          list[currentIndex++] = item;
        }
      }
    }
  }

  // Hàm InsertionSort để sắp xếp các phần tử trong mỗi bucket
  void Insertion_Sort_Quan(List<int> list)
  {
    for (int i = 1; i < list.length; i++)
    {
      int key = list[i];
      int j = i - 1;
      while (j >= 0 && list[j] > key)
      {
        list[j + 1] = list[j];
        j--;
      }
      list[j + 1] = key;
    }
  }

  // INTRO SORT
  void introSort(List<int> list, int start, int end) {
    int depthLimit = (2 * (log(end - start + 1) ~/ ln2)) as int;
    _introSortUtil(list, start, end, depthLimit);
  }

  void _introSortUtil(List<int> list, int start, int end, int depthLimit) {
    while (end - start > 16) {
      if (depthLimit == 0) {
        _heapSort(list, start, end);
        return;
      }
      depthLimit--;
      int pivot = _partition(list, start, end);
      _introSortUtil(list, pivot + 1, end, depthLimit);
      end = pivot - 1;
    }
    _insertionSort(list, start, end);
  }

  int _partition(List<int> list, int low, int high) {
    int pivot = list[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if (list[j] <= pivot) {
        i++;
        _swap(list, i, j);
      }
    }
    _swap(list, i + 1, high);
    return i + 1;
  }

  void _heapSort(List<int> list, int start, int end) {
    int n = end - start + 1;

    for (int i = n ~/ 2 - 1; i >= start; i--) {
      _heapify(list, n, i, start);
    }

    for (int i = end; i >= start; i--) {
      _swap(list, start, i);
      _heapify(list, i - start, start, start);
    }
  }

  void _heapify(List<int> list, int n, int i, int start) {
    int largest = i;
    int l = 2 * i + 1 - start;
    int r = 2 * i + 2 - start;

    if (l < n && list[start + l] > list[start + largest]) {
      largest = l;
    }

    if (r < n && list[start + r] > list[start + largest]) {
      largest = r;
    }

    if (largest != i) {
      _swap(list, start + i, start + largest);
      _heapify(list, n, largest, start);
    }
  }

  void _insertionSort(List<int> list, int start, int end) {
    end -=1 ;
    for (int i = start + 1; i <= end; i++) {
      int key = list[i];
      int j = i - 1;

      while (j >= start && list[j] > key) {
        list[j + 1] = list[j];
        j--;
      }
      list[j + 1] = key;
    }
  }

  void _swap(List<int> list, int i, int j) {
    int temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  //MERGE SORT
  void Merge_Sort(List<int> list, int start, int end) {
    if (start < end) {
      int mid = (start + end) ~/ 2;

      Merge_Sort(list, start, mid);
      Merge_Sort(list, mid + 1, end);

      merge_quan(list, start, mid, end);
    }
  }

  void merge_quan(List<int> list, int start, int mid, int end) {
    int leftSize = mid - start + 1;
    int rightSize = end - mid;

    List<int> leftList = List<int>.filled(leftSize, 0);
    List<int> rightList = List<int>.filled(rightSize, 0);

    for (int i = 0; i < leftSize; i++) {
      leftList[i] = list[start + i];
    }

    for (int j = 0; j < rightSize; j++) {
      rightList[j] = list[mid + 1 + j];
    }

    int i = 0, j = 0, k = start;

    while (i < leftSize && j < rightSize) {
      if (leftList[i] <= rightList[j]) {
        list[k] = leftList[i];
        i++;
      } else {
        list[k] = rightList[j];
        j++;
      }
      k++;
    }

    while (i < leftSize) {
      list[k] = leftList[i];
      i++;
      k++;
    }

    while (j < rightSize) {
      list[k] = rightList[j];
      j++;
      k++;
    }
  }


  // SHELL SORT
  void shellSort(List<int> list, int start, int end) {
    int n = end - start + 1;

    // Bắt đầu với một khoảng cách lớn, sau đó giảm dần khoảng cách
    for (int gap = n ~/ 2; gap > 0; gap ~/= 2) {
      // Thực hiện chèn khoảng cách cho khoảng cách này
      for (int i = start + gap; i <= end; i++) {
        int temp = list[i];
        int j;

        // Dịch chuyển các phần tử đã được sắp xếp trước đó lên trên cho đến khi tìm được vị trí đúng của list[i]
        for (j = i; j >= start + gap && list[j - gap] > temp; j -= gap) {
          list[j] = list[j - gap];
        }

        // Đặt temp (giá trị ban đầu của list[i]) vào vị trí đúng của nó
        list[j] = temp;
      }
    }
  }


}
