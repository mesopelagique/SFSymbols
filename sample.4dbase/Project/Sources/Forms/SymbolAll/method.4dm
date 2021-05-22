

// XXX todo into a process to not block ui
Form:C1466.symbols:=Split string:C1554(Folder:C1567(fk resources folder:K87:11).file("list.txt").getText("UTF-8"; Document with LF:K24:22); "\n").map("toObject")