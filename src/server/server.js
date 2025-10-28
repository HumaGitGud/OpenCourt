const express = require('express')
const router =  require("./routers/router")
const cors = require('cors');

const app = express()
const port = process.env.PORT || 3000

app.use(express.json());
app.use(cors());
app.use("/", router)

app.listen(port, () => {
  console.log(`Open Court API listening on port ${port}`)
})
