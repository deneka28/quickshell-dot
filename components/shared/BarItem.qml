import QtQuick


Rectangle {
  id: root
  default required property Item item
  color: "transparent"
  radius: 10

  implicitWidth: item.width
  implicitHeight: 30
  children: [item]
}
