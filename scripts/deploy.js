const hre = require("hardhat");

async function main() {
  const TokenPath = await hre.ethers.getContractFactory("TokenPath");
  const initialSupply = hre.ethers.parseEther("1000000"); // 1 million tokens
  const tokenPath = await TokenPath.deploy(initialSupply);

  await tokenPath.waitForDeployment();
  console.log("✅ TokenPath deployed to:", await tokenPath.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
