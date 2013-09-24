object false
child(@products.order('id ASC')) { extends "spree/api/products/bulk_show" }
node(:count) { @products.count }
node(:total_count) { @products.total_count }
