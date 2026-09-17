// Simulates NIP account enquiry with a realistic delay.
// Returns a deterministic name based on the last 2 digits of the account number.
Future<String?> lookupAccountName(String accountNumber) async {
  if (accountNumber.length != 10) return null;
  final index = int.tryParse(accountNumber.substring(8));
  if (index == null) return null;

  final delay = 300 + (int.tryParse(accountNumber[9]) ?? 5) * 60;
  await Future<void>.delayed(Duration(milliseconds: delay));

  const names = [
    'Amara Okonkwo', 'Chidi Eze', 'Ngozi Adeyemi', 'Emeka Nwosu',
    'Fatima Bello', 'Tunde Okafor', 'Aisha Musa', 'Chukwu Obiora',
    'Funke Adebayo', 'Yemi Lawal', 'Kemi Ogundele', 'Dayo Afolabi',
    'Bisi Adetunji', 'Seun Olawale', 'Tobi Nwachukwu', 'Ade Bakare',
    'Uche Obi', 'Chiamaka Onyeka', 'Musa Ibrahim', 'Halima Sule',
  ];
  return names[index % names.length];
}
