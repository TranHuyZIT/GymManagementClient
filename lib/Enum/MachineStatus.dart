class MachineStatus{
  static List<String> status = ["Tốt", "Khá Tốt", "Hư Hỏng Nhẹ", "Không Thể Sử Dụng"];
  static String defaultStatus = status[0];
  static List<String> getAllStatus(){
    return status;
  }
}