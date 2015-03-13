# GeckoBoard Config
Gecko.config do |c|
  c.api_key = ENV['gboard_api_key']
  c.http_builder { |builder| builder.adapter :em_http }
end

# Geckoboard widgets
$text_widget = Gecko::Widget::Text 
$ns_widget = Gecko::Widget::NumberSecondaryStat
$funnel_widget = Gecko::Widget::Funnel
$geckometer_widget = Gecko::Widget::Geckometer
$line_widget = Gecko::Widget::Line 
$pie_widget = Gecko::Widget::Pie
$rag_widet = Gecko::Widget::Rag
$ragcol_widget = Gecko::Widget::RagColumns


## Number and Seconday Value Widget(s)

### For Opportunities
$o_ns_wkey = ENV['o_ns_wkey']
$o_funnel_wkey = ENV['o_funnel_wkey']
$o_line_wkey = ENV['o_line_wkey']
$expected_value_wkey = ENV['expected_value_wkey']
