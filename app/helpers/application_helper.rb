module ApplicationHelper
  
  ###########################
  # Build Data from Closeio #
  ###########################
  # Leads

  # Return number of leads
  def all_leads
    $closeio.list_leads['total_results']
    # Return integer
  end


  # Opportunities

  def number_of_opportunities
    $closeio.list_opportunities['total_results']
    # Return integer
  end

  def opportunities
    $closeio.list_opportunities['data']
    # Return array of opportunities
  end

  def filter(dataset, criteria, query=nil)
    if criteria.instance_of? String
      dataset.select { |data| data[criteria].downcase =~ /#{Regexp.quote(query)}/i }
    end
    # Return array of 'given' opportunities status or label type
  end

  #   # 1. qualified
  def qualified
    filter(opportunities, 'status_label', 'qualified')
    # Return array of qualified
  end 
  #   # 2. agreed to follow up
  def atgfu
    filter(opportunities, 'status_label', 'agreed to follow up')
    # Return arry of agtfu
  end
  #   # 3. value confirmed
  def value_confirmed
    filter(opportunities, 'status_label', 'value confirmed')
    # Return arry of confirmed
  end

  #   # 4. proposal presented
  def proposal_presented
    filter(opportunities, 'status_label', 'proposal presented')
    # Return array of proposal presented
   end
  #   # 5. won
  def won
    filter(opportunities, 'status_label', 'won')
    # Return array of won
  end
  #   # 6. lost
  def lost
    filter(opportunities, 'status_label', 'lost')
    # Return array of lost
  end

  ###########################
  # Push Data to Geckoboard #
  ###########################

  # Opportunities: Number and secondary chart
  def active_opportunities_widget
    widget = $ns_widget.new($o_ns_wkey)
    widget.primary_text = "Active Opportunities"
    widget.primary_value = filter(opportunities, 'status_type', 'active').size
    widget.update { |success, result, widget_key|  puts success ? "Updated" : "Error updating #{widget_key}"}
    # Return http request object
  end

  
  def expected_value_widget
    widget = $ns_widget.new($expected_value_wkey)
    widget.primary_text = "Expected Value of Opportunities"
    widget.primary_value = filter(opportunities, 'status_type', 'active').inject(0) {|expected_value, opportunity| expected_value + ((opportunity['value']/100) * opportunity['confidence']/100) }
    widget.primary_prefix = "$"
    widget.update { |success, result, widget_key|  puts success ? "Updated" : "Error updating #{widget_key}"}
    # Return http request object
  end

  # Opportunities: Funnel Graph
  def opportunities_funnel_widget
    widget = $funnel_widget.new($o_funnel_wkey)

    ### Build dataset
    # Qualified
    widget.add(qualified.size, 'Qualified')
    # Agreed to Follow Up
    widget.add(atgfu.size, 'Agreed to Follow Up')
    # Value Confirmed
    widget.add(value_confirmed.size, 'Value Confirmed')
    # Proposal Presented
    widget.add(proposal_presented.size, 'Proposal Presented')
    # Won
    widget.add(won.size, 'Won')

    widget.update { |success, result, widget_key|  puts success ? "Updated" : "Error updating #{widget_key}"}
    # Return http request object
  end
  
  # Opportunities: Line Graph
  def opportunities_line_widget
    widget = $line_widget.new($o_line_wkey)

     
    ### Build dataset
    dataset = []
    first_week = Date.today.beginning_of_year.cweek
    current_week = Date.today.cweek
    last_week = Date.today.end_of_year.cweek
    
    Array(first_week..current_week).each do |week|
      dataset << opportunities.select { |opportunity| opportunity['date_created'].to_date.cweek == week }.size
    end
    widget.items = dataset
    # X-axis
    # widget.x_axis = *(first_week..current_week).collect { |week| "Week" + " " + week.to_s }
    widget.x_axis = *(first_week..current_week)
    # Y-xis
    widget.y_axis =*(dataset.min..dataset.max)
    # widget.y_axis =*(Date.today.beginnning_of_year.strftime("%B")..Date.today.end_of_year.strftime("%B"))
    # Item:[] -- > opportunities/month from beginning of year

    widget.update { |success, result, widget_key|  puts success ? "Updated" : "Error updating #{widget_key}"}
    # Return http request object
  end


end
