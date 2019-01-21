package run

import (
	"github.com/urfave/cli"
)

// Command is the command of run
var Command = cli.Command{
	Name:  "run",
	Usage: "run test by benchmark data",
	Flags: Flags,
	Subcommands: []cli.Command{
		AccountCaseCommand,
		TransferCaseCommand,
		ContractCaseCommand,
		CommonVoteCaseCommand,
		VoteCaseCommand,
		VoteNodeCaseCommand,
		BenchmarkCommand,
		BenchmarkTokenCommand,
		BenchmarkToken721Command,
		BenchmarkSystemCommand,
		BenchmarkAccountCommand,
	},
}

// Flags is the flags of run command
var Flags = []cli.Flag{
	cli.StringFlag{
		Name:  "keys, k",
		Value: "",
		Usage: "Load keys from `FILE`",
	},
	cli.StringFlag{
		Name:  "config, c",
		Value: "",
		Usage: "Load itest configuration from `FILE`",
	},
	cli.StringFlag{
		Name:  "code",
		Value: "",
		Usage: "Load contract code from `FILE`",
	},
	cli.StringFlag{
		Name:  "abi",
		Value: "",
		Usage: "Load contract abi from `FILE`",
	},
	cli.StringFlag{
		Name:  "account, a",
		Value: "accounts.json",
		Usage: "The account file that itest would load from if exists",
	},
	cli.IntFlag{
		Name:  "anum",
		Value: 100,
		Usage: "The number of accounts to generated if no given account file",
	},
}
