<div class="container wow fadeIn">
<%# Heading  %>
  <h2 class="my-5 h2 text-center">Checkout form</h2>
    <%# Grid row %>
      <div class="row">
          <%# Grid column %>
                  <div class="col-md-8 mb-4">
                    <%# Card %>
                        <div class = "card">
                          <%# Card content  %>
                            <form class="card-body">
                              <%# Grid row %>
                                <div class="row">
                                  <%# Grid column %>
<%= form_with model: @order, url:order_path(@order), method: :patch do |f|%>
  <div class="col-md-6 mb-2">
        <%# firstName %>
        <div class="md-form">
            <div class="form-group ">
        <%= f.label :customer_name %>
           <%=f.text_field  :customer_name,  class:"form-control",placeholder:"Name" %>
           <%# <%=f.label :customer_name, placeholder:"Name"   %>
          </div>
          </div>
          <%# Grid colum %>
          <%# Grid colum %>
      </div>
    <%# email %>
<div class = "md-form mb-5">
<%= f.label :email %>
<%=f.text_field :email, class:"form-control",placeholder:"youremail@example.com"%>
<%# <%=f.label :email%> 
</div>
<div class = "md-form mb-5">
<%= f.label :address %>
<%=f.text_field :address, class:"form-control", placeholder:"Shipping Address"%>  
</div>
<div class = "md-form mb-5">
<%= f.label :last_four_cc %>
<%=f.text_field :last_four_cc, class:"form-control", placeholder:"Enter Only Last Four of CC"%>  
</div>
<div class = "md-form mb-5">
<%= f.label :exp_date %>
<%=f.text_field :exp_date, class:"form-control", placeholder:"Expiry Date"%>  
</div>
<div class = "md-form mb-5">
<%= f.label :cvv%>
<%=f.text_field :cvv, placeholder:"Security Code"%> 
</div>
<div class = "md-form mb-5">
<%= f.label :zip %>
<%=f.text_field :zip, placeholder:"Zip Code"%>  
</div>
<div class = "md-form mb-5">
<%= f.submit "Submit order", class: "btn btn-primary waves-effect waves-light" %>
</div>
</div>   
<%end%>            
<h4 class="col-md-4 mb-4">
                                          
<%# Heading %>
<h4 class="d-flex justify-content-between align-utems-center mb-3">
    <span class="text-muted">Your cart</span>
    <span class="badge badge-secondary badge=pill">0</span>
    </h4>
    <%# cart %>
    <ul class="list-group mb-3 z-depth-1">
      <li class="list-group-item d-flex justify-content-between lh-condensed"></li>
        <div>
          <h6 class="my-0">Product name</h6>
            <small class="text-muted">Price</span>
            </li>
           