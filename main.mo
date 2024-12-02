import Trie "mo:base/Trie";
import Option "mo:base/Option";
import Nat32 "mo:base/Nat32";

actor UserManager {
  public type UserId = Nat32;

  public type User = {
    name : Text;
    budget : Nat;
    k_urunler : [Text];
  };

  private stable var next : UserId = 0;

  private stable var users : Trie.Trie<UserId, User> = Trie.empty();

  // Kullanıcı oluşturma fonksiyonu
  public func create(name: Text) : async UserId {
    let userId = next;
    next += 1;
    let new_user : User = {
      name = name;
      budget = 100; // Başlangıç bütçesi 100 lira
      k_urunler = []; // Başlangıçta boş ürün listesi
    };
    users := Trie.replace(
      users,
      key(userId),
      Nat32.equal,
      ?new_user
    ).0;
    return userId;
  };

  // Kullanıcıyı okuma fonksiyonu
  public query func read(userId: UserId) : async ?User {
    let result = Trie.find(users, key(userId), Nat32.equal);
    return result;
  };

  // Kullanıcıyı güncelleme fonksiyonu
  public func update(userId: UserId, user: User) : async Bool {
    let result = Trie.find(users, key(userId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      users := Trie.replace(
        users,
        key(userId),
        Nat32.equal,
        ?user
      ).0;
    };
    return exists;
  };

  // Kullanıcıyı silme fonksiyonu
  public func delete(userId: UserId) : async Bool {
    let result = Trie.find(users, key(userId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      users := Trie.replace(
        users,
        key(userId),
        Nat32.equal,
        null
      ).0;
    };
    return exists;
  };

  private func key(x: UserId) : Trie.Key<UserId> {
    return {hash = x; key = x};
  };
};
