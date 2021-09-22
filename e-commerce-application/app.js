var express = require("express");
var app = express();
var bodyParser = require("body-parser");
var mongoose = require("mongoose");
var methodOverride = require("method-override");
var passport = require("passport");
var localStrategy = require("passport-local");
var passportLocalMongoose = require("passport-local-mongoose");
var Product = require("./models/product");
var Review = require("./models/review");
var Order = require("./models/order");
var User = require("./models/user");
var OrderCount = require("./models/orderCount");
var flash = require("connect-flash");

const dotenv = require('dotenv');
dotenv.config();
 		  
var dbURL = process.env.DATABASEURL || 'mongodb://localhost:27017/apniDukaan';
mongoose.connect(dbURL, {useNewUrlParser: true});

app.set("view engine","ejs");
app.use(express.static(__dirname + "/public"));
app.use(bodyParser.urlencoded({extended: true}));
app.use(methodOverride("_method"));
app.use(flash());

app.use(require("express-session")({
	secret: "abd",
	resave: false,
	saveUninitialized: false
}));

app.use(passport.initialize());
app.use(passport.session());

passport.use(new localStrategy(User.authenticate()));
passport.serializeUser(User.serializeUser());
passport.deserializeUser(User.deserializeUser());

app.use(function(req,res,next){
	res.locals.currentUser = req.user;
	res.locals.error = req.flash("error");
	res.locals.success = req.flash("success");
	next();
});

var indexRoutes = require("./routes/index");
var productRoutes = require("./routes/product");
var reviewRoutes = require("./routes/review");
var cartRoutes = require("./routes/cart");
var checkoutRoutes = require("./routes/checkout");
var orderRoutes = require("./routes/order");

app.use(indexRoutes)
app.use(productRoutes);
app.use(reviewRoutes);
app.use(cartRoutes)
app.use(checkoutRoutes);
app.use(orderRoutes);

OrderCount.find({},function(err,orderCountObjects){
	if(orderCountObjects.length==0) {
		OrderCount.create({count: 0});
	}
});

app.listen(process.env.PORT || 3000, process.env.IP);