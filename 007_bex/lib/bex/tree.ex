defprotocol Bex.Tree do
  def insert(tree, key, value)
  def find(tree, key)
  def delete(tree, key)
  def height(tree)
end
